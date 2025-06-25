/* eslint-disable prettier/prettier */
// src/email/interfaces/email-options.interface.ts
export interface EmailOptions { // <-- Garanta que tem "export interface"
  to: string;
  subject: string;
  html?: string;
  template?: string; // Nome do template (ex: 'welcome')
  context?: any; // Dados para o template
  from?: string; // <--- ADICIONE ESTA LINHA (opcional)

}