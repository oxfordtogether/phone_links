class C::ReportsController < C::CController
  def new
    @match = Match.find(params[:match_id])
    @report = Report.new(match_id: @match.id, date_of_call: Date.today)

    @callee_feeling_options = [{ 'icon': "emoji-angry-fill", value: "awful", selected_classes: "bg-yellow-200 border-2", unselected_classes: "border", classes: "rounded-md p-3 bg-white text-yellow-300 border-yellow-400", icon_classes: "w-7 h-7 rounded-full bg-gray-500 border-gray-500 border" },
                               { 'icon': "emoji-frown-fill", value: "bad", selected_classes: "bg-yellow-200 border-2", unselected_classes: "border", classes: "rounded-md p-3 bg-white text-yellow-300 border-yellow-400", icon_classes: "w-7 h-7 rounded-full bg-gray-500 border-gray-500 border" },
                               { 'icon': "emoji-neutral-fill", value: "neutral", selected_classes: "bg-yellow-200 border-2", unselected_classes: "border", classes: "rounded-md p-3 bg-white text-yellow-300 border-yellow-400", icon_classes: "w-7 h-7 rounded-full bg-gray-500 border-gray-500 border" },
                               { 'icon': "emoji-smile-fill", value: "good", selected_classes: "bg-yellow-200 border-2", unselected_classes: "border", classes: "rounded-md p-3 bg-white text-yellow-300 border-yellow-400", icon_classes: "w-7 h-7 rounded-full bg-gray-500 border-gray-500 border" },
                               { 'icon': "emoji-heart-eyes-fill", value: "great", selected_classes: "bg-yellow-200 border-2", unselected_classes: "border", classes: "rounded-md p-3 bg-white text-yellow-300 border-yellow-400", icon_classes: "w-7 h-7 rounded-full bg-gray-500 border-gray-500 border" }]

    @caller_feeling_options = [{ 'icon': "thumb-up", value: "awful", selected_classes: "bg-red-200 border-2", unselected_classes: "border", classes: "rounded-md p-3 bg-white text-red-400 border-red-300", icon_classes: "w-7 h-7 transform rotate-180" },
                               { 'icon': "thumb-up", value: "bad", selected_classes: "bg-red-100 border-2", unselected_classes: "border", classes: "rounded-md p-3 bg-white text-red-300 border-red-200", icon_classes: "w-7 h-7 transform -rotate-135" },
                               { 'icon': "thumb-up", value: "neutral", selected_classes: "bg-yellow-100 border-2", unselected_classes: "border", classes: "rounded-md p-3 bg-white text-yellow-400 border-yellow-300", icon_classes: "w-7 h-7 transform -rotate-90" },
                               { 'icon': "thumb-up", value: "good", selected_classes: "bg-green-50 border-2", unselected_classes: "border", classes: "rounded-md p-3 bg-white text-green-300 border-green-200", icon_classes: "w-7 h-7 transform -rotate-45" },
                               { 'icon': "thumb-up", value: "great", selected_classes: "bg-green-100 border-2", unselected_classes: "border", classes: "rounded-md p-3 bg-white text-green-400 border-green-300", icon_classes: "w-7 h-7" }]
  end

  def create
    @report = Report.new(report_params)

    if @report.save
      redirect_to c_callee_path(@current_caller, @report.match.callee), notice: "Report was successfully created."
    else
      @match_id = @report.match.id
      render :new
    end
  end

  private

  def report_params
    params.require(:report).permit(:match_id, :duration, :summary, :date_of_call, :callee_feeling, :caller_feeling, :concerns, :concerns_notes)
  end
end
