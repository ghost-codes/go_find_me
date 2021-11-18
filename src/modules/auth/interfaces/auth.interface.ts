export interface SignUpInterface {
  email: string;
  password: string;
  username: string;
}

export interface UserReponseModel {
  id?: string;
  username: string;
  email: string;
  phone_number: string;
}

export interface AuthenticationResponse {
  user: UserReponseModel;
  accessToken: string;
  refreshToken: string;
}
