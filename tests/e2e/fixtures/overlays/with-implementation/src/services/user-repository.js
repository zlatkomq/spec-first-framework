export function createUserRepository() {
  const users = new Map();

  return {
    save(user) {
      if (users.has(user.email)) {
        throw new Error('Email already in use');
      }
      users.set(user.email, user);
      return user;
    },

    findByEmail(email) {
      return users.get(email) || null;
    },
  };
}
