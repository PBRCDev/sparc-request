# Copyright © 2011-2016 MUSC Foundation for Research Development~
# All rights reserved.~

# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:~

# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.~

# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following~
# disclaimer in the documentation and/or other materials provided with the distribution.~

# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products~
# derived from this software without specific prior written permission.~

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,~
# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT~
# SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL~
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS~
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR~
# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.~

class StudyTypeFinder

	def initialize(study, answers=nil)
		@study = study
    @answers = answers
		@active_answers = Array.new
		@inactive_answers_version_1 = Array.new
    @inactive_answers_version_2 = Array.new
		@study_type = nil
	end

	def study_type
    if @study.nil?
      @study_type = determine_study_type(3, @answers)
		elsif @study.study_type_answers.present?
			if @study.active?
        # VERSION 3 STQ
  			StudyTypeQuestion.active.find_each do |stq|
          @active_answers << stq.study_type_answers.find_by_protocol_id(@study.id).answer 
        end
        @study_type = determine_study_type(3, @active_answers)

      elsif @study.version_type == 1
        # VERSION 1 STQ
        StudyTypeQuestion.joins(:study_type_question_group).where(study_type_question_groups: { version: 1 }).find_each do |stq|
          @inactive_answers_version_1 << stq.study_type_answers.find_by_protocol_id(@study.id).answer 
        end

        @study_type = determine_study_type(1, @inactive_answers_version_1)

      elsif @study.version_type == 2
        # VERSION 2 STQ
        StudyTypeQuestion.joins(:study_type_question_group).where(study_type_question_groups: { version: 2 }).find_each do |stq|
          @inactive_answers_version_2 << stq.study_type_answers.find_by_protocol_id(@study.id).answer
        end

        @study_type = determine_study_type(2, @inactive_answers_version_2)
      end
  	end
    @study_type
  end

  def determine_study_type(version, answers)
    case version
    when 3
      study_type_ans_constant = STUDY_TYPE_ANSWERS_VERSION_3
    when 2
      study_type_ans_constant = STUDY_TYPE_ANSWERS_VERSION_2
    when 1
      study_type_ans_constant = STUDY_TYPE_ANSWERS
    end

    study_type_ans_constant.each do |k, v|
      if v == answers
        @study_type = k
        break
      end
    end
    @study_type
  end

  def determine_study_type_note
    STUDY_TYPE_NOTES.each do |k, v|
      if k == study_type
        @note = v
        break
      end
    end
    @note
  end
end