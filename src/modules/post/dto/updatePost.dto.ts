export class UpdatePostDTO {
  id: string;
  imgs: string[];
  userId: string[];
  title: string;
  desc: string;
  lastSeen: LastSeen;
}
export class LastSeen {
  location: string;
  date: Date;
}
