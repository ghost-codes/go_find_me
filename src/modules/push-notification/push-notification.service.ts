import { Injectable } from '@nestjs/common';
import {} from 'onesignal-api-client-nest';
import {
  NotificationByDeviceBuilder,
  OneSignalAppClient,
} from 'onesignal-api-client-core';

@Injectable()
export class PushNotificationService {
  // constructor(private readonly oneSignalService: OneSignalService) {}

  async createNotificationSingle(message: string, uid: string) {
    const client = new OneSignalAppClient(
      process.env.ONE_SIGNAL_APP_ID,
      process.env.ONE_SIGNAL_API_KEY,
    );
    console.log(uid);
    const input = new NotificationByDeviceBuilder()
      .setIncludeExternalUserIds([uid])
      .notification() // .email()
      .setContents({ en: message })
      .build();

    const result = await client.createNotification(input);
    console.log(result);
  }
}
