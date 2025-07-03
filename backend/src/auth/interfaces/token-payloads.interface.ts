export interface RefreshTokenPayload {
  sub: string;
  email: string;
  iat?: number;
  exp?: number;
}

export interface PasswordResetTokenPayload {
  sub: string;
  type: 'password_reset';
  iat?: number;
  exp?: number;
}
