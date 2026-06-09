import { Role } from '@prisma/client';
export declare class RegisterDto {
    firstName: string;
    lastName: string;
    email: string;
    password: string;
    phoneNumber?: string;
    role?: Role;
    organizerName?: string;
}
