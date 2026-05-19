import { describe, it, beforeEach } from 'node:test';
import assert from 'node:assert/strict';
import { createRegistrationService } from '../../src/services/registration-service.js';
import { createUserRepository } from '../../src/services/user-repository.js';
import { createInviteRepository } from '../../src/services/invite-repository.js';

describe('RegistrationService', () => {
  let service;
  let userRepository;
  let inviteRepository;

  beforeEach(() => {
    userRepository = createUserRepository();
    inviteRepository = createInviteRepository(['valid-invite']);
    service = createRegistrationService({ userRepository, inviteRepository });
  });

  it('registers a user with valid inputs', () => {
    const result = service.register({
      email: 'user@example.com',
      password: 'validPass123',
      inviteCode: 'valid-invite',
    });
    assert.equal(result.success, true);
    assert.ok(result.user);
    assert.equal(result.user.email, 'user@example.com');
  });

  it('rejects invalid invite code', () => {
    const result = service.register({
      email: 'user@example.com',
      password: 'validPass123',
      inviteCode: 'bad-code',
    });
    assert.equal(result.success, false);
    assert.equal(result.error, 'Invalid invite code');
  });

  it('rejects duplicate email', () => {
    service.register({
      email: 'user@example.com',
      password: 'validPass123',
      inviteCode: 'valid-invite',
    });
    inviteRepository.addInvite('second-invite');
    const result = service.register({
      email: 'user@example.com',
      password: 'validPass123',
      inviteCode: 'second-invite',
    });
    assert.equal(result.success, false);
    assert.equal(result.error, 'Email already in use');
  });

  it('rejects weak password', () => {
    const result = service.register({
      email: 'user@example.com',
      password: 'short',
      inviteCode: 'valid-invite',
    });
    assert.equal(result.success, false);
    assert.ok(result.error.includes('8 characters'));
  });

  it('rejects already-used invite code', () => {
    service.register({
      email: 'first@example.com',
      password: 'validPass123',
      inviteCode: 'valid-invite',
    });
    const result = service.register({
      email: 'second@example.com',
      password: 'validPass123',
      inviteCode: 'valid-invite',
    });
    assert.equal(result.success, false);
    assert.equal(result.error, 'Invite code already used');
  });
});
