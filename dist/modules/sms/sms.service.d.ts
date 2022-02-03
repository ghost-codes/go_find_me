export declare class SmsService {
    private twilioClient;
    constructor();
    intiatePhoneNumberVerification(phone_number: string, message: string): Promise<import("twilio/lib/rest/api/v2010/account/message").MessageInstance>;
}
