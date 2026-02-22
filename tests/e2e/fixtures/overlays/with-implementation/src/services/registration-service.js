import { validatePassword, hashPassword } from '../utils/password-utils.js';
import { createUser } from '../models/user-model.js';

export function createRegistrationService({ userRepository, inviteRepository }) {
  return {
    register({ email, password, inviteCode }) {
      // Validate invite code
      const invite = inviteRepository.findByCode(inviteCode);
      if (!invite) {
        return { success: false, error: 'Invalid invite code' };
      }
      if (invite.used) {
        return { success: false, error: 'Invite code already used' };
      }

      // Check email uniqueness
      const existing = userRepository.findByEmail(email);
      if (existing) {
        return { success: false, error: 'Email already in use' };
      }

      // Validate password
      const passwordResult = validatePassword(password);
      if (!passwordResult.valid) {
        return { success: false, error: passwordResult.reason };
      }

      // Create user
      const passwordHash = hashPassword(password);
      const user = createUser({ email, passwordHash });
      userRepository.save(user);

      // Consume invite
      inviteRepository.markUsed(inviteCode, email);

      return { success: true, user };
    },
  };
}
