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
  private transporter;
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
      host: this.configService.get('EMAIL_HOST'),
      port: this.configService.get('EMAIL_PORT'),
      secure: this.configService.get('EMAIL_SECURE'),
      auth: {
        user: this.configService.get('EMAIL_USER'),
        pass: this.configService.get('EMAIL_PASS'),
      },
    });
  }

  async sendEmail(options: EmailOptions): Promise<boolean> {
    try {
      const mailOptions = {
        from: options.from || this.configService.get('EMAIL_FROM'),
        to: options.to,
        subject: options.subject,
        html: this.renderTemplate(options.template, options.context),
      };

      await this.transporter.sendMail(mailOptions);
      
      await this.logEmail({
        to: options.to,
        subject: options.subject,
        template: options.template,
        status: 'success',
      });

      return true;
    } catch (error) {
      this.logger.error(`Failed to send email: ${error.message}`);
      
      await this.logEmail({
        to: options.to,
        subject: options.subject,
        template: options.template,
        status: 'failed',
        error: error.message,
      });

      return false;
    }
  }

  private renderTemplate(templateName: string, context: object = {}): string {
    const template = TEMPLATES[templateName];
    if (!template) throw new Error(`Template ${templateName} not found`);

    return Object.entries(context).reduce(
      (html, [key, value]) => 
        html.replace(new RegExp(`{{${key}}}`, 'g'), value),
      template
    );
  }

    private async logEmail(logData: Partial<EmailLog>): Promise<void> {
    await this.emailLogRepository.save(
        this.emailLogRepository.create(logData)
    );
    }
}