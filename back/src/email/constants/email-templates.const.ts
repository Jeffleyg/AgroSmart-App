export const TEMPLATES = {
    WELCOME: `
      <h1>Bem-vindo, {{name}}!</h1>
      <p>Seu cadastro foi realizado com sucesso.</p>
    `,
    PASSWORD_RESET: `
      <h1>Redefinição de Senha</h1>
      <p>Use este código: <strong>{{code}}</strong></p>
    `,
    PASSWORD_CHANGED: `
      <h1>Senha Alterada</h1>
      <p>Sua senha foi alterada com sucesso.</p>
    `,
  };