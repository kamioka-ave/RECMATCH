class Mypage::Students::Wizard::StudentsController < Mypage::Students::Wizard::BaseController
  #before_action :not_suitable, only: [:create]

  def show
    @student = current_user.student.present? ? current_user.student : Student.new
  end

  def create
    if current_user.student.present?
      @student = current_user.student
      @student.assign_attributes(student_params)
    else
      @student = Student.new(student_params)
      @student.user_id = current_user.id
    end

    @profile = current_user.profile
    @agreement = current_user.student_agreement
    #@interview = current_user.student_interview

    begin
      ActiveRecord::Base.transaction do
        @student.save!(context: :registration)
        @agreement.update!(student_id: @student.id)
        @profile.update!(name: @student.nickname, gender: @student.gender)
        #@interview.update!(student_id: @student.id)
      end
      redirect_to mypage_student_wizard_confirm_path
    rescue => e
      render :show
    end

  end

  def update
    @student = current_user.student

    if @student.status == Student::S_REJECTED
      history = StudentHistory.new_with_student(@student)
      @student.assign_attributes(student_params)
      @student.reapplied = true

      if @student.valid?(:registration)
        ActiveRecord::Base.transaction do
          history.save!
          @student.revision += 1
          @student.save!
        end
        redirect_to mypage_student_wizard_confirm_path
      else
        render :show
      end
    else
      @student.assign_attributes(student_params)

      if @student.save(context: :registration)
        redirect_to mypage_student_wizard_confirm_path
      else
        render :show
      end
    end
  end

  def univfaculty
    @facultyname = []
    @univ = params[:univ]
    uri = Addressable::URI.parse("https://webservice.recruit.co.jp/shingaku/school/v1/?key=abc2341d1669f0ef&format=json&name=#{@univ}&order=3")
    @query = uri.query
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.open_timeout = 5
      http.read_timeout = 10
      http.get(uri.request_uri)
    end
    # 例外処理の開始
    begin
      # responseの値に応じて処理を分ける
      case response
        # 成功した場合
        when Net::HTTPSuccess
          # responseのbody要素をJSON形式で解釈し、hashに変換
          @result = JSON.parse(response.body)
          # 表示用の変数に結果を格納
          @facultysize = @result["results"]["school"][0]["faculty"].size
          @facultysize.times do |i|
            @facultyname.push @result["results"]["school"][0]["faculty"][i]["name"]
          end
          # 別のURLに飛ばされた場合
        when Net::HTTPRedirection
          @message = "Redirection: code=#{response.code} message=#{response.message}"
          # その他エラー
        else
          @message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
        end
        # エラー時処理
        rescue IOError => e
          @message = "e.message"
        rescue TimeoutError => e
          @message = "e.message"
        rescue JSON::ParserError => e
          @message = "e.message"
        rescue => e
          @message = "e.message"
      end
      render plain: @facultyname.to_json
  end

def univdepartment
  @departname = []
  @univ = params[:univ]
  @faculty = params[:faculty].to_i
  uri = Addressable::URI.parse("https://webservice.recruit.co.jp/shingaku/school/v1/?key=abc2341d1669f0ef&format=json&name=#{@univ}&order=3")
  @query = uri.query
  response = Net::HTTP.start(uri.host, uri.port) do |http|
    http.open_timeout = 5
    http.read_timeout = 10
    http.get(uri.request_uri)
  end
  # 例外処理の開始
  begin
    # responseの値に応じて処理を分ける
    case response
      # 成功した場合
      when Net::HTTPSuccess
        # responseのbody要素をJSON形式で解釈し、hashに変換
        @result = JSON.parse(response.body)
        # 表示用の変数に結果を格納
        @departsize = @result["results"]["school"][0]["faculty"][@faculty]["department"].size
        @departsize.times do |i|
          @departname.push @result["results"]["school"][0]["faculty"][@faculty]["department"][i]
        end
        # 別のURLに飛ばされた場合
      when Net::HTTPRedirection
        @message = "Redirection: code=#{response.code} message=#{response.message}"
        # その他エラー
      else
        @message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
      end
      # エラー時処理
      rescue IOError => e
        @message = "e.message"
      rescue TimeoutError => e
        @message = "e.message"
      rescue JSON::ParserError => e
        @message = "e.message"
      rescue => e
        @message = "e.message"
    end
    render plain: @departname.to_json
end

  private

  def student_params
    params.require(:student).permit(
      :first_name, :first_name_kana, :last_name, :last_name_kana, :nickname, :gender, :birth_on, :zip_code, :prefecture_id, :city, :address1, :address2,
      :phone, :phone_mobile, :university, :university_name, :bunri, :depart,:graduation_year, :graduation_month, :labo, :circle, :club, :industry_1, :industry_2, :industry_3,
      :occupation_1, :occupation_2, :occupation_3, :jobhuntingaxis_text, :jobhuntingaxis, :intern_is, :intern_company, :intern_detail, :toeic_score, :mypr, :qualifications
    )
  end

  def not_suitable
    if current_user.student_interview.not_suitable?
      render template: 'mypage/students/wizard/interviews/nonconform'
    end
  end

end