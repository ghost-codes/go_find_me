export interface CreatePost {
    imgs: string[];
    user_id: string;
    title: string;
    desc: string;
    lastSeen: LastSeen;
}
export declare class LastSeen {
    location: string;
    date: Date;
}
export interface UpdatePost {
    id: string;
    imgs: string[];
    user_id: string;
    title: string;
    desc: string;
    lastSeen: LastSeen;
}
