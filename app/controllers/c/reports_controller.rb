class C::ReportsController < C::CController
  def new
    @match = Match.find(params[:match_id])
    @report = Report.new(match_id: @match.id, date_of_call: Date.today)

    @callee_state_options = [{ 'icon': "emoji-angry-fill", value: "awful", selected_classes: "text-yellow-300", unselected_classes: "text-yellow-100", classes: "border border-yellow-400 bg-gray-600 hover:text-yellow-300 rounded-full" },
                             { 'icon': "emoji-frown-fill", value: "bad", selected_classes: "text-yellow-300", unselected_classes: "text-yellow-100", classes: "border border-yellow-400 bg-gray-600 hover:text-yellow-300 rounded-full" },
                             { 'icon': "emoji-neutral-fill", value: "neutral", selected_classes: "text-yellow-300", unselected_classes: "text-yellow-100", classes: "border border-yellow-400 bg-gray-600 hover:text-yellow-300 rounded-full" },
                             { 'icon': "emoji-smile-fill", value: "good", selected_classes: "text-yellow-300", unselected_classes: "text-yellow-100", classes: "border border-yellow-400 bg-gray-600 hover:text-yellow-300 rounded-full" },
                             { 'icon': "emoji-heart-eyes-fill", value: "great", selected_classes: "text-yellow-300", unselected_classes: "text-yellow-100", classes: "border border-yellow-400 bg-gray-600 hover:text-yellow-300 rounded-full" }]

    @caller_state_options = [{ 'icon': "thumb-up", value: "awful", selected_classes: "border-2 border-gray-400", unselected_classes: "", classes: "transform rotate-180 p-1 text-red-400" },
                             { 'icon': "thumb-up", value: "bad", selected_classes: "border-2 border-gray-400", unselected_classes: "", classes: "transform -rotate-135 p-1 text-red-300" },
                             { 'icon': "thumb-up", value: "neutral", selected_classes: "border-2 border-gray-400", unselected_classes: "", classes: "transform -rotate-90 p-1 text-yellow-300" },
                             { 'icon': "thumb-up", value: "good", selected_classes: "border-2 border-gray-400", unselected_classes: "", classes: "transform -rotate-45 p-1 text-green-300" },
                             { 'icon': "thumb-up", value: "great", selected_classes: "border-2 border-gray-400", unselected_classes: "", classes: "p-1 text-green-400" }]
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
    params.require(:report).permit(:match_id, :duration, :summary, :date_of_call, :callee_state, :caller_confidence, :concerns, :concerns_notes)
  end
end
