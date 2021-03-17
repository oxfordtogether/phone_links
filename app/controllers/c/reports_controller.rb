class C::ReportsController < C::CController
  before_action :feeling_options, only: %i[new create]

  def new
    return redirect_to c_path(@current_caller) unless params[:match_id].present?

    @match = @fetcher.match(params[:match_id])
    @report = Report.new(match_id: @match.id, date_of_call: Date.today)
  end

  def create
    # check that match is valid for caller
    @match = @fetcher.match(report_params["match_id"])

    report_params_hash = report_params.to_h
    report_params_hash["concern_notes"] = nil unless report_params_hash["concerns"]
    if report_params_hash["duration"] == "no_answer"
      report_params_hash["summary"] = nil
      report_params_hash["callee_feeling"] = nil
      report_params_hash["caller_feeling"] = nil
    else
      report_params_hash["no_answer_notes"] = nil
    end

    @report = Report.new(report_params_hash)

    if @report.save
      redirect_to c_match_path(@current_caller, @match), notice: "Report was successfully created."
    else
      render :new
    end
  end

  private

  def feeling_options
    @callee_feeling_options = [{ 'icon': "openmoji-crying-face", value: "awful", selected_classes: "bg-yellow-200 border-2", unselected_classes: "border", classes: "rounded-md p-2 bg-white text-yellow-300 border-yellow-400", icon_classes: "w-10 h-10 rounded-full" },
                               { 'icon': "openmoji-slightly-frowining-face", value: "bad", selected_classes: "bg-yellow-200 border-2", unselected_classes: "border", classes: "rounded-md p-2 bg-white text-yellow-300 border-yellow-400", icon_classes: "w-10 h-10 rounded-full" },
                               { 'icon': "openmoji-neutral-face", value: "neutral", selected_classes: "bg-yellow-200 border-2", unselected_classes: "border", classes: "rounded-md p-2 bg-white text-yellow-300 border-yellow-400", icon_classes: "w-10 h-10 rounded-full" },
                               { 'icon': "openmoji-slightly-smiling-face", value: "good", selected_classes: "bg-yellow-200 border-2", unselected_classes: "border", classes: "rounded-md p-2 bg-white text-yellow-300 border-yellow-400", icon_classes: "w-10 h-10 rounded-full" },
                               { 'icon': "openmoji-grinning-face", value: "great", selected_classes: "bg-yellow-200 border-2", unselected_classes: "border", classes: "rounded-md p-2 bg-white text-yellow-300 border-yellow-400", icon_classes: "w-10 h-10 rounded-full" }]

    @caller_feeling_options = [{ 'icon': "thumb-up", value: "awful", selected_classes: "bg-red-200 border-2", unselected_classes: "border", classes: "rounded-md p-3 bg-white text-red-400 border-red-300", icon_classes: "w-7 h-7 transform rotate-180" },
                               { 'icon': "thumb-up", value: "bad", selected_classes: "bg-red-100 border-2", unselected_classes: "border", classes: "rounded-md p-3 bg-white text-red-300 border-red-200", icon_classes: "w-7 h-7 transform -rotate-135" },
                               { 'icon': "thumb-up", value: "neutral", selected_classes: "bg-yellow-100 border-2", unselected_classes: "border", classes: "rounded-md p-3 bg-white text-yellow-400 border-yellow-300", icon_classes: "w-7 h-7 transform -rotate-90" },
                               { 'icon': "thumb-up", value: "good", selected_classes: "bg-green-50 border-2", unselected_classes: "border", classes: "rounded-md p-3 bg-white text-green-300 border-green-200", icon_classes: "w-7 h-7 transform -rotate-45" },
                               { 'icon': "thumb-up", value: "great", selected_classes: "bg-green-100 border-2", unselected_classes: "border", classes: "rounded-md p-3 bg-white text-green-400 border-green-300", icon_classes: "w-7 h-7" }]
  end

  def report_params
    params.require(:report).permit(:match_id, :duration, :summary, :no_answer_notes, :date_of_call, :callee_feeling, :caller_feeling, :concerns, :concerns_notes)
  end
end
