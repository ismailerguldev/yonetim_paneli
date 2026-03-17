import type { Response } from "express";
import projectService from "../services/project.service.js";
import type { IProject } from "../models/project.model.js";
import type { RequestUser } from "@/models/user.model.js";
import { success } from "zod";
export const createProject = async (req: RequestUser, res: Response) => {
    const userId = req.user!.id;
    const project: IProject = req.body;
    const result = await projectService.createProject({ project: project, userId: userId });
    res.status(200).json({
        status: result,
        message: "success"
    })
};
export const getProjects = async (req: RequestUser, res: Response) => {
    const userId = req.user!.id
    const result = await projectService.getProjects(userId);
    res.status(200).json({
        status: true,
        projects: result
    })
}
export const getProjectDetail = async (req: RequestUser, res: Response) => {
    const projectId = req.query.projectId as string;
    const result = await projectService.getProjectDetail(projectId);
    res.status(200).json({
        status: true,
        project: result
    })
}
export const removeProject = async (req: RequestUser, res: Response) => {
    const { projectId } = req.body
    const result = await projectService.removeProject(projectId, req.user!.id);
    res.status(200).json({
        status: result,
        message: "success"
    })
}
export const createProjectTask = async (req: RequestUser, res: Response) => {
    const { task } = req.body
    const result = await projectService.createProjectTask(task);
    res.status(200).json({
        success: result,
        mesage: "success"
    })
}
export const updateProjectTask = async (req: RequestUser, res: Response) => {
    const { taskId, value } = req.body;
    const result = await projectService.updateProjectTask(taskId, value)
    res.status(200).json({
        success: result,
        message: "success"
    })

}
export const deleteProjectTask = async (req: RequestUser, res: Response) => {
    const { taskId } = req.body
    const result = await projectService.deleteProjectTask(taskId);
    res.status(200).json({
        success: result,
        message: "success"
    })
}