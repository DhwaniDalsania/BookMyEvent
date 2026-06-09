export declare class CreateOrganizerDto {
    userId: string;
    name: string;
    description?: string;
    logoUrl?: string;
    contactEmail: string;
    contactPhone?: string;
}
export declare class UpdateOrganizerDto {
    name?: string;
    description?: string;
    logoUrl?: string;
    contactEmail?: string;
    contactPhone?: string;
    isVerified?: boolean;
}
