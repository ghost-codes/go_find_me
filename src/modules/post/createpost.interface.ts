export interface CreatePost {
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

export interface UpdatePost {
  id: string;
  imgs: string[];
  userId: string[];
  title: string;
  desc: string;
  lastSeen: LastSeen;
}
