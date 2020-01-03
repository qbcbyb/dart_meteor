import { Meteor } from 'meteor/meteor';
import { Accounts } from 'meteor/accounts-base';
import { Messages } from '../lib/collections.js';

console.log('Creating user1...');
try {
  Accounts.createUser({
    username: 'user1',
    password: 'password1',
    profile: {
      name: 'John',
      surname: 'Doe'
    },
  });
} catch (e) {
  console.log(e.message);
}

console.log('Creating user2...');
try {
  Accounts.createUser({
    username: 'user2',
    password: 'password2',
    profile: {
      name: 'Apple',
      surname: 'Seed'
    },
  });
} catch (e) {
  console.log(e.message);
}

Meteor.methods({
  sum(x, y) {
    return x + y;
  },
  authSum(x, y) {
    if (!this.userId) {
      throw new Meteor.Error(401, 'Unauthorized!');
    }
    return x + y;
  },
  alwaysThrow() {
    throw new Meteor.Error(500, 'Internal Server Error!');
  },
});

Meteor.publish({
  'messages.all'() {
    return Messages.find({});
  },
  'messages.currentUser'() {
    return Messages.find({
      owner: this.userId(),
    });
  },
});