export declare class LastSeen {
    location: string;
    date: Date;
}
export declare class UpdatePostDTO {
    id: string;
    imgs: string[];
    user_id: string;
    title: string;
    desc: string;
    status: string;
    lastSeen: LastSeen;
}
