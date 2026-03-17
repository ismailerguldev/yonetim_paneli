export interface IProject {
    id?:string
    name:string
    description:string
    priority:string
    end_date: string
}
export interface ITask {
    id?:string
    description:string
    is_done?:number
    project_id:string
}