const {Client} = require('pg');
const {mapUsers} = require('./utils/mapUsers');

const configs = {
    host: 'localhost',
    port: 5432,
    user: 'postgres',
    password: '7825',
    database: 'fd_test'
}

const client = new Client(configs);


const users = [
    {
        firstName: 'Test1',
        lastName: 'Test2',
        email: '12w345@dsdf'
    },
    {
        firstName: 'Test2',
        lastName: 'Test3',
        email: '1231q45@dsdf'
    },
    {
        firstName: 'Test3',
        lastName: 'Test4',
        email: '12g345@dsdf'
    },
    {
        firstName: 'Test44',
        lastName: 'Test5',
        email: '12wee45@dsdf'
    },
    {
        firstName: 'Test6',
        lastName: 'Test27',
        email: '12wqe345@dsdf'
    }
]

async function start() {
    await client.connect();
   const {rows} = await client.query(`INSERT INTO users (first_name, last_name, email) VALUES ${mapUsers(users)};`);
   console.log(rows);
   await client.end();
}


start();