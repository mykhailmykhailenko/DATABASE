const {User, client} = require('./models/index');
const {getUsers} = require('./api/index');



async function start() {
    await client.connect();

    const usersArray = await getUsers();

   const {rows} = await User.bulkCreate(usersArray);

   await client.end();
}

start();