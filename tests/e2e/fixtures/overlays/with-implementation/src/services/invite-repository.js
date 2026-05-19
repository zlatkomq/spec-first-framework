export function createInviteRepository(initialInvites = []) {
  const invites = new Map();
  for (const code of initialInvites) {
    invites.set(code, { code, used: false, usedBy: null });
  }

  return {
    findByCode(code) {
      return invites.get(code) || null;
    },

    markUsed(code, email) {
      const invite = invites.get(code);
      if (!invite) throw new Error('Invite not found');
      invite.used = true;
      invite.usedBy = email;
    },

    addInvite(code) {
      invites.set(code, { code, used: false, usedBy: null });
    },
  };
}
