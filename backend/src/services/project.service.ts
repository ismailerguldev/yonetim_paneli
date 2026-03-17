import { InternalError, NotFoundError, UnauthorizedError } from "../models/error.model.js";
import type { IProject, ITask } from "../models/project.model.js"
import projectRepository from "../repositories/project.repository.js";
import { v4 as uuid } from "uuid"
const createProject = async (data: { project: IProject, userId: string }) => {
    const { project, userId } = data;
    if (!userId) throw new UnauthorizedError("Kullanıcı yok!");
    project.id = uuid();
    return await projectRepository.createProject(project, userId);
}
const getProjects = async (userId: string) => {
    if (!userId) throw new UnauthorizedError("Kullanıcı yok!");
    return await projectRepository.getProjects(userId);
}
const getProjectDetail = async (projectId: string) => {
    const rows = await projectRepository.getProjectDetail(projectId);
    if (rows.length === 0 || !rows[0]) throw new NotFoundError("Proje bulunamadı");
    return {
        description: rows[0].description,
        tasks: rows[0].taskId !== null ? rows.map(row => ({ id: row.taskId, description: row.taskDescription, isDone: row.taskIsDone === 1 })) : [],
        progress: rows[0].progress
    }
}
const removeProject = async (projectId: string, userId: string) => {
    if (!userId) throw new UnauthorizedError("Kullanıcı yok!");
    const result = await projectRepository.removeProject(projectId, userId);
    if (!result) throw new InternalError("Bir hata oluştu.");
    return result
}
const createProjectTask = async (task: ITask) => {
    task.id = uuid();
    const isSuccess = await projectRepository.createProjectTask(task);
    if (!isSuccess) throw new InternalError("Bir hata meydana geldi.");
    return isSuccess
}
const updateProjectTask = async (taskId: string, value: number) => {
    const isSuccess = await projectRepository.updateProjectTask(taskId, value);
    if (!isSuccess) throw new InternalError("Bir hata meydana geldi");
    return isSuccess
}
const deleteProjectTask = async (taskId: string) => {
    const isSuccess = await projectRepository.deleteProjectTask(taskId);
    if (!isSuccess) throw new InternalError("Bir hata meydana geldi");
    return isSuccess
}
export default {
    createProject,
    getProjectDetail,
    getProjects,
    createProjectTask,
    updateProjectTask,
    deleteProjectTask,
    removeProject
}