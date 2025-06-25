/* eslint-disable prettier/prettier */
// src/email/constants/email-templates.const.ts
export const TEMPLATES = {
  'welcome': `
    <h1>Bem-vindo ao AgroSmart!</h1>
    <p>Olá {{name}},</p>
    <p>Agradecemos por se cadastrar em nossa plataforma. Seja bem-vindo!</p>
    <p>Atenciosamente,<br>Equipe AgroSmart</p>
  `,
  'alert': `
    <h1>ALERTA AGRONÔMICO: {{city}}</h1>
    <p>Olá,</p>
    <p>Foi detectada uma <strong>previsão de frio intenso</strong> na cidade de <strong>{{city}}</strong>.</p>
    <p><strong>Mensagem do Alerta:</strong> {{message}}</p>
    <p>Por favor, tome as medidas necessárias para proteger suas culturas.</p>
    <p>Atenciosamente,<br>Equipe AgroSmart</p>
  `,
};