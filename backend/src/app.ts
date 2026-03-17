console.log("🚨 APP.TS VERSION 123 🚨");
import express from 'express';
import cors from 'cors';
import { errorMiddleware } from './middlewares/error.middleware.js';
import authRoutes from './routes/auth.routes.js';
import cookieParser from "cookie-parser"
import projectRoutes from './routes/project.route.js';
const app = express();

app.use(cors({
  origin: "*",
  credentials: true,
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser())
app.use((req, res, next) => {
  console.log("REQUEST:", req.url);
  next();
});
app.use('/api/auth', authRoutes);
app.use("/api/project", projectRoutes)
app.use(errorMiddleware);
export default app;
