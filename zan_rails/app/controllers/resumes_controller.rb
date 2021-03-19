class ResumesController < ApplicationController
      
  def new   
    @resume = Resume.new  
    @resumes = Resume.all   
  end   
      
  def create   
    @resume = Resume.new(resume_params)   
      
    if @resume.save   
      redirect_to new_resume_path, notice: "Successfully uploaded."   
    else   
      render "new"   
    end   
        
  end   
      
  def destroy   
      @resume = Resume.find(params[:id])   
      @resume.destroy   
      redirect_to new_resume_path, notice:  "Successfully deleted."   
  end   
  
  private   
    def resume_params   
      params.require(:resume).permit(:name, :attachment)   
    end   
end
