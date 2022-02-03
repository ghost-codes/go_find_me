import { Injectable } from '@nestjs/common';
import { OneSignalService } from 'onesignal-api-client-nest';
import { NotificationByDeviceBuilder } from 'onesignal-api-client-core';

@Injectable()
export class PushNotificationService {
  constructor(private readonly oneSignalService: OneSignalService) {}

  async createNotificationSingle(message: string, uid: string) {
    const input = new NotificationByDeviceBuilder()
      .setIncludeExternalUserIds([uid])
      .notification() // .email()
      .setContents({ en: message })
      .build();

    await this.oneSignalService.createNotification(input);
  }
}
