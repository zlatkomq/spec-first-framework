import { randomUUID } from 'node:crypto';

export function createUser({ email, passwordHash }) {
  return {
    id: randomUUID(),
    email,
    passwordHash,
    createdAt: new Date(),
  };
}
