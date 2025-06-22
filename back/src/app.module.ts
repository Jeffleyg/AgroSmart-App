import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { HttpModule } from '@nestjs/axios';
import { User } from './user/user.entity';
import { UserModule } from './user/user.module';
import { AuthModule } from './auth/auth.module';
//import { EmailModule } from './email/email.module';
import { WeatherModule } from './weather/weather.module';
import { ConfigModule } from '@nestjs/config';
import { AlertModule } from  './alert/alert.module';
import { Alert } from './alert/alert.entity';
import { EmailModule} from './email/email.module';



@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: 'localhost',
      port: 5432,
      username: 'postgres',
      password: 'jean',
      database: 'user_auth',
      // entities: [User], 
      autoLoadEntities: true, // <--- ADICIONE ESTA LINHA

      synchronize: true, // ATENÇÃO: usar apenas em desenvolvimento

    }),
    HttpModule,
    UserModule,
    AuthModule,
    EmailModule,
    // WeatherModule,
    ConfigModule.forRoot({ isGlobal: true }),
    // AlertModule,

  ],
})
export class AppModule {}
