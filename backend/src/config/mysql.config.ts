import mysql from "mysql2/promise";
const connection = await mysql.createConnection({
    host: process.env.MYSQL_HOST as string,
    user: process.env.MYSQL_USER as string,
    password: process.env.MYSQL_PASSWORD as string,
    database: process.env.MYSQL_DATABASE as string,
    port: Number(process.env.MYSQL_PORT)
})
const [rows] = await connection.query("SELECT @@port as port, @@hostname as hostname")
console.log(rows)
export default connection;