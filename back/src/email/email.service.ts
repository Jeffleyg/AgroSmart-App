/* eslint-disable @typescript-eslint/no-unsafe-return */
/* eslint-disable prettier/prettier */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
import { Injectable, Logger } from '@nestjs/common';
import * as nodemailer from 'nodemailer';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { EmailLog } from './entities/email-log.entity';
import { EmailOptions } from './interfaces/email-options.interface';
import { TEMPLATES } from './constants/email-templates.const';

@Injectable()
export class EmailService {
  private transporter: nodemailer.Transporter;
  private readonly logger = new Logger(EmailService.name);

  constructor(
    private configService: ConfigService,
    @InjectRepository(EmailLog)
    private emailLogRepository: Repository<EmailLog>,
  ) {
    this.initTransport();
  }

  private initTransport() {
    this.transporter = nodemailer.createTransport({
      host: this.configService.get<string>('EMAIL_HOST'),
      port: this.configService.get<number>('EMAIL_PORT'),
      secure: this.configService.get<boolean>('EMAIL_SECURE'), // Geralmente false para 587, true para 465
      auth: {
        user: this.configService.get<string>('EMAIL_USER'),
        pass: this.configService.get<string>('EMAIL_PASS'),
      },
      tls: {
        // <--- ADICIONE ESTA SEÇÃO AQUI
        rejectUnauthorized: false // <--- DESABILITA A VALIDAÇÃO DE CERTIFICADO (APENAS PARA DEV/DEBUG!)
      }
    });
  }

  async sendEmail(options: EmailOptions): Promise<boolean> {
    let finalHtmlContent: string | undefined;

    const initialLog = this.emailLogRepository.create({
      to: options.to,
      subject: options.subject,
      templateName: options.template,
      templateContext: options.context,
      body: options.html,
      status: 'pending',
    });
    await this.emailLogRepository.save(initialLog);

    try {
      if (options.template) {
        finalHtmlContent = this.renderTemplate(options.template, options.context || {});
      } else if (options.html) {
        finalHtmlContent = options.html;
      } else {
        throw new Error('Neither HTML content nor template specified for email.');
      }

      const mailOptions = {
        from: options.from || this.configService.get<string>('EMAIL_FROM'),
        to: options.to,
        subject: options.subject,
        html: finalHtmlContent,
      };

      await this.transporter.sendMail(mailOptions);

      initialLog.status = 'success';
      initialLog.body = finalHtmlContent ?? '';
      await this.emailLogRepository.save(initialLog);

      this.logger.log(`Email sent successfully to ${options.to}`);
      return true;

    } catch (error: any) {
      this.logger.error(`Failed to send email to ${options.to}: ${error.message}`);

      initialLog.status = 'failed';
      initialLog.error = error.message;
      initialLog.body = finalHtmlContent ?? '';
      await this.emailLogRepository.save(initialLog);

      return false;
    }
  }

  private renderTemplate(templateName: string, context: object = {}): string {
    const template = TEMPLATES[templateName];
    if (!template) {
      this.logger.error(`Template "${templateName}" not found in TEMPLATES constant.`);
      throw new Error(`Template "${templateName}" not found.`);
    }

    return Object.entries(context).reduce(
      (html, [key, value]) =>
        html.replace(new RegExp(`{{${key}}}`, 'g'), String(value)),
      template
    );
  }
}