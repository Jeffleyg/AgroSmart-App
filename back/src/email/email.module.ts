import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EmailService } from './email.service';
import { EmailController } from './email.controller';
import { EmailLog } from './entities/email-log.entity';
import { ConfigModule } from '@nestjs/config';

@Module({
    imports: [
    TypeOrmModule.forFeature([EmailLog]),
    ConfigModule,
    ],
    providers: [EmailService],
    controllers: [EmailController],
    exports: [EmailService],
})
export class EmailModule {}