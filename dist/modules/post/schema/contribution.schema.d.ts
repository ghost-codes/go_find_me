/// <reference types="mongoose" />
export declare type ContributionDocument = Contribution & Document;
export declare class Contribution {
    location_sighted: string;
    post_id: string;
    time_sighted: Date;
    date_sighted: Date;
    created_at: Date;
    updated_at: Date;
}
export declare const ContributionSchema: import("mongoose").Schema<import("mongoose").Document<Contribution, any, any>, import("mongoose").Model<import("mongoose").Document<Contribution, any, any>, any, any, any>, {}>;
