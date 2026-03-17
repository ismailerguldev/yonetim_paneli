import { createProject, createProjectTask, deleteProjectTask, getProjectDetail, getProjects, removeProject, updateProjectTask } from "../controllers/project.controller.js";
import { authMiddleware } from "../middlewares/auth.middleware.js";
import { Router } from "express";

const route = Router();
route.post("/create", authMiddleware, createProject)
route.get("/get", authMiddleware, getProjects)
route.get("/get/detail", authMiddleware, getProjectDetail)
route.post("/create/task", authMiddleware, createProjectTask)
route.put("/task/update", authMiddleware, updateProjectTask)
route.delete("/task/delete", authMiddleware, deleteProjectTask)
route.put("/remove", authMiddleware, removeProject)
export default route