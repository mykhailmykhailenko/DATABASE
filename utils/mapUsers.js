module.exports.mapUsers = (usersArray) => {
    return usersArray.map(user => `('${user.firstName}', '${user.lastName}', '${user.email}')`).join(',');
 }