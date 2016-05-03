# Copyright © 2011 MUSC Foundation for Research Development
# All rights reserved.

# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following
# disclaimer in the documentation and/or other materials provided with the distribution.

# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products
# derived from this software without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
# SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

$(document).ready ->

  epic_box_alert_message = () ->
    options = {
      resizable: false,
      height: 220,
      modal: true,
      autoOpen: false,
      buttons:
        "OK": ->
          $(this).dialog("close")
    }
    $('#epic_box_alert').dialog(options).dialog("open")

  $.prototype.hide_elt = () ->
    this[0].selectedIndex = 0
    this.closest('.row').hide()
    return this

  $.prototype.show_elt = () ->
    this.closest('.row').show()
    return this

  $.prototype.hide_visual_error = () ->
    this.removeClass('visual_error')
    if $('.visual_error').length == 0
      $('.study_type div').removeClass('field_with_errors')
      if $('#errorExplanation ul li').size() == 1
        $('#errorExplanation').remove()
      else
        $('#errorExplanation ul li:contains("Study type questions must be selected")').remove()

  add_and_check_visual_error_on_submit = (dropdown) ->
    if dropdown.is(':visible') && dropdown.val() == ''
      dropdown.addClass('visual_error')
      dropdown.on 'change', (e) ->
        dropdown.hide_visual_error()

  add_and_check_visual_error_on_field_change = (dropdown) ->
    siblings = dropdown.parent('.row').siblings().find('.visual_error')
    if siblings
      for sibling in siblings
        if !$(sibling).is(':visible')
          $(sibling).hide_visual_error()

  $(document).on 'change', "input[name='protocol[selected_for_epic]']", ->
    # Publish Study in Epic - Radio
    switch $('#selected_for_epic_button .btn input:radio:checked').val()
      when 'true'
        $('.selected_for_epic_dependent').show()
        $('#study_type_answer_certificate_of_conf_answer').show_elt()
      when 'false'
        $('.selected_for_epic_dependent').hide()
        $('#study_type_answer_certificate_of_conf_answer').hide_elt().trigger 'change'

  $(document).on 'change', '#study_type_answer_certificate_of_conf_answer', (e) ->
    new_value = $(e.target).val()
    if new_value == 'false'
      $('#study_type_answer_higher_level_of_privacy_answer').show_elt()
    else
      $('#study_type_answer_higher_level_of_privacy_answer').hide_elt()
      $('#study_type_answer_access_study_info_answer').hide_elt()
      $('#study_type_answer_epic_inbasket_answer').hide_elt()
      $('#study_type_answer_research_active_answer').hide_elt()
      $('#study_type_answer_restrict_sending_answer').hide_elt()
    return

  $(document).on 'change', '#study_type_answer_higher_level_of_privacy_answer', (e) ->
    new_value = $(e.target).val()
    if new_value == 'false'
      $('#study_type_answer_access_study_info_answer').hide_elt()
      $('#study_type_answer_epic_inbasket_answer').show_elt()
      $('#study_type_answer_research_active_answer').show_elt()
      $('#study_type_answer_restrict_sending_answer').show_elt()
    else
      $('#study_type_answer_access_study_info_answer').show_elt()
      $('#study_type_answer_epic_inbasket_answer').hide_elt()
      $('#study_type_answer_research_active_answer').hide_elt()
      $('#study_type_answer_restrict_sending_answer').hide_elt()
    return

  $(document).on 'change', '#study_type_answer_access_study_info_answer', (e) ->
    new_value = $(e.target).val()
    if new_value == 'false'
      $('#study_type_answer_epic_inbasket_answer').show_elt()
      $('#study_type_answer_research_active_answer').show_elt()
      $('#study_type_answer_restrict_sending_answer').show_elt()
    else
      $('#study_type_answer_epic_inbasket_answer').hide_elt()
      $('#study_type_answer_research_active_answer').hide_elt()
      $('#study_type_answer_restrict_sending_answer').hide_elt()
    return

  # When the epic box answers hit the validations with an unselected field,
  # the html.haml sets display to none for unselected fields
  # So if the user has not filled out one of the
  # required fields in the epic box, it will hit this code and display
  # the appropriate fields that need to be filled out with a visual cue of red border
  if $('.field_with_errors label:contains("Study type questions")').length > 0
    $('#selected_for_epic_button').change()
    if $('#study_type_answer_certificate_of_conf_answer').is(':visible')
      $('#study_type_answer_certificate_of_conf_answer').change()
    if $('#study_type_answer_higher_level_of_privacy_answer').val() == 'true'
      $('#study_type_answer_access_study_info_answer').show_elt()
      $('#study_type_answer_access_study_info_answer').change()
    if $('#study_type_answer_higher_level_of_privacy_answer').val() == 'false'
      $('#study_type_answer_higher_level_of_privacy_answer').change()
    if $('#study_type_answer_certificate_of_conf_answer') != "" && $('#study_type_answer_higher_level_of_privacy_answer').val() != "" && $('#study_type_answer_access_study_info_answer').val() == 'false'
      $('#study_type_answer_access_study_info_answer').change()
    add_and_check_visual_error_on_submit($('#study_type_answer_certificate_of_conf_answer'))
    add_and_check_visual_error_on_submit($('#study_type_answer_higher_level_of_privacy_answer'))
    add_and_check_visual_error_on_submit($('#study_type_answer_access_study_info_answer'))
    add_and_check_visual_error_on_submit($('#study_type_answer_epic_inbasket_answer'))
    add_and_check_visual_error_on_submit(research_active_dropdown)
    add_and_check_visual_error_on_submit($('#study_type_answer_restrict_sending_answer'))

    $('#study_type_answer_certificate_of_conf_answer').on 'change', (e) ->
      add_and_check_visual_error_on_field_change($('#study_type_answer_certificate_of_conf_answer'))

    $('#study_type_answer_higher_level_of_privacy_answer').on 'change', (e) ->
      add_and_check_visual_error_on_field_change($('#study_type_answer_higher_level_of_privacy_answer'))

    $('#study_type_answer_access_study_info_answer').on 'change', (e) ->
      add_and_check_visual_error_on_field_change($('#study_type_answer_access_study_info_answer'))

  #### This was written for an edge case in admin/portal.
  #### When you go from a virgin project (selected_for_epic = nil/ never been a study)
  #### to a study, the Epic Box should be editable instead of only displaying the epic box data.

  if $('#study_can_edit_admin_study').val() == "can_edit_study"
    $('#actions input[type="submit"]').on 'click', (e) ->
      if $('input[name=\'study[selected_for_epic]\']:checked').val() == 'true'
        if $('#study_type_answer_certificate_of_conf_answer').val() == ''
          epic_box_alert_message()
          add_and_check_visual_error_on_submit($('#study_type_answer_certificate_of_conf_answer'))
          return false
        if $('#study_type_answer_certificate_of_conf_answer').val() == 'false'
          if $('#study_type_answer_higher_level_of_privacy_answer').val() == ''
            epic_box_alert_message()
            add_and_check_visual_error_on_submit($('#study_type_answer_higher_level_of_privacy_answer'))
            return false
          if $('#study_type_answer_higher_level_of_privacy_answer').val() == 'true'
            if $('#study_type_answer_access_study_info_answer').val() == ''
              epic_box_alert_message()
              add_and_check_visual_error_on_submit($('#study_type_answer_access_study_info_answer'))
              return false
            if $('#study_type_answer_access_study_info_answer').val() == 'false'
              if $('#study_type_answer_epic_inbasket_answer').val() == '' ||$('#study_type_answer_research_active_answer').val() == '' || $('#study_type_answer_restrict_sending_answer').val() == ''
                epic_box_alert_message()
                add_and_check_visual_error_on_submit($('#study_type_answer_epic_inbasket_answer'))
                add_and_check_visual_error_on_submit(research_active_dropdown)
                add_and_check_visual_error_on_submit($('#study_type_answer_restrict_sending_answer'))
                return false
          else if $('#study_type_answer_higher_level_of_privacy_answer').val() == 'false'
            if $('#study_type_answer_epic_inbasket_answer').val() == '' ||$('#study_type_answer_research_active_answer').val() == '' || $('#study_type_answer_restrict_sending_answer').val() == ''
              epic_box_alert_message()
              add_and_check_visual_error_on_submit($('#study_type_answer_epic_inbasket_answer'))
              add_and_check_visual_error_on_submit(research_active_dropdown)
              add_and_check_visual_error_on_submit($('#study_type_answer_restrict_sending_answer'))
              return false

  ######## End of send to epic study question logic ##############


  $(document).on 'change', '.study#protocol_funding_status', ->
    # Proposal Funding Status - Dropdown
    $('.funding_status_dependent').hide()
    switch $(this).val()
      when 'funded'
        $('.funded').show()
        $('#protocol_funding_source').trigger('change')
      when 'pending_funding' then $('.pending_funding').show()

  $(document).on 'change', "#protocol_funding_source", ->
    # Funding Source - Dropdown
    $('.funding_source_dependent').hide()
    switch $(this).val()
      when 'federal' then $('.federal').show()
      when 'internal' then $('.internal').show()


  $(document).on 'change', '#protocol_research_types_info_attributes_human_subjects', ->
    # Human Subjects - Checkbox
    switch $(this).attr('checked')
      when 'checked' then $('.human_subjects_dependent').show()
      else $('.human_subjects_dependent').hide()

  $(document).on 'change', '#protocol_research_types_info_attributes_vertebrate_animals', ->
    # Vertebrate Animals - Checkbox
    switch $(this).attr('checked')
      when 'checked' then $('.vertebrate_animals_dependent').show()
      else $('.vertebrate_animals_dependent').hide()

  $(document).on 'change', '#protocol_research_types_info_attributes_investigational_products', ->
    # Investigational Products - Checkbox
    switch $(this).attr('checked')
      when 'checked' then $('.investigational_products_dependent').show()
      else $('.investigational_products_dependent').hide()

  $(document).on 'change', '#protocol_research_types_info_attributes_ip_patents', ->
    # IP/Patents - Checkbox
    switch $(this).attr('checked')
      when 'checked' then $('.ip_patents_dependent').show()
      else $('.ip_patents_dependent').hide()

  $(document).on 'change', '#protocol_impact_areas_attributes_6__destroy', ->
    # Impact Areas Other - Checkbox
    switch $(this).attr('checked')
      when 'checked' then $('.impact_area_dependent').show()
      else $('.impact_area_dependent').hide()

  $(document).on 'change', '.project#protocol_funding_status', ->
    # Proposal Funding Status - Dropdown
    $('.funding_status_dependent').hide()
    switch $(this).val()
      when 'funded' then $('.funded').show()
      when 'pending_funding' then $('.pending_funding').show()



  #********** Primary PI TypeAhead Input Handling Begin **********
  if $('#protocol_project_roles_attributes_0_identity_id[type="text"]').length > 0
    identities_bloodhound = new Bloodhound(
      datumTokenizer: (datum) ->
        Bloodhound.tokenizers.whitespace datum.value
      queryTokenizer: Bloodhound.tokenizers.whitespace
      remote:
        url: '/dashboard/associated_users/search_identities?term=%QUERY',
        wildcard: '%QUERY'
    )
    identities_bloodhound.initialize() # Initialize the Bloodhound suggestion engine
    $('#protocol_project_roles_attributes_0_identity_id[type="text"]').typeahead(
      # Instantiate the Typeahead UI
      {
        minLength: 3
        hint: false
        highlight: true
      }
      {
        displayKey: 'label'
        source: identities_bloodhound.ttAdapter()
      }
    )
    .on 'typeahead:select', (event, suggestion) ->
      $("#protocol_project_roles_attributes_0_identity_id[type='hidden']").val(suggestion.value)
      $("#protocol_project_roles_attributes_0_identity_id[type='text']").hide()
      $("#primary_pi_name").text("#{suggestion.label}").show()
      $("#user-select-clear-icon").show()

    $('#user-select-clear-icon').live 'click', ->
      $("#primary_pi_name").text("").hide()
      $('#user-select-clear-icon').hide()
      $("#protocol_project_roles_attributes_0_identity_id[type='hidden']").val('')
      $("#protocol_project_roles_attributes_0_identity_id[type='text']").val('').show()
  #********** Primary PI TypeAhead Input Handling End **********
