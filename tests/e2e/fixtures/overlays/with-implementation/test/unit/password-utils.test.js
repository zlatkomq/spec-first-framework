import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { validatePassword, hashPassword } from '../../src/utils/password-utils.js';

describe('validatePassword', () => {
  it('rejects passwords shorter than 8 characters', () => {
    const result = validatePassword('short');
    assert.equal(result.valid, false);
    assert.ok(result.reason);
  });

  it('accepts passwords of 8 or more characters', () => {
    const result = validatePassword('validPass1');
    assert.equal(result.valid, true);
  });

  it('rejects empty password', () => {
    const result = validatePassword('');
    assert.equal(result.valid, false);
  });
});

describe('hashPassword', () => {
  it('produces a hash different from the input', () => {
    const hash = hashPassword('myPassword123');
    assert.notEqual(hash, 'myPassword123');
    assert.ok(hash.includes(':'));
  });
});
