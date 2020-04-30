# Copyright © 2011-2020 MUSC Foundation for Research Development
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

class NottificationsReport < ReportingModule
  $canned_reports << name unless $canned_reports.include? name # update global variable so that we can populate the list, report won't show in the list without this, unless is necessary so we don't add on refresh in dev. mode

  def self.title
    "Notifications"
  end

  # see app/reports/test_report.rb for all options
  def default_options
    {
      "Date Range"  => { field_type: :date_range, for: "messages_created_at", from: '2000-01-01'.to_date, to: Date.today },
      Institution   => { field_type: :select_tag, has_dependencies: "true" },
      Provider      => { field_type: :select_tag, dependency: '#institution_id', dependency_id: 'parent_id', from: '2000-01-01'.to_date, to: Date.today },
      Program       => { field_type: :select_tag, dependency: '#provider_id', dependency_id: 'parent_id' },
      Core          => { field_type: :select_tag, dependency: '#program_id', dependency_id: 'parent_id '}
    }
  end

  # see app/reports/test_report.rb for all options
  def column_attrs
    attrs = {}

    attrs["SRID"]                 = "notification.sub_service_request.try(&:ssr_id)"
    attrs["Request Organization"] = "notification.sub_service_request.try(&:organization).try(&:name)"
    attrs["From"]                 = "sender.full_name"
    attrs["To"]                   = "recipient.full_name"
    attrs["Date"]                 = "created_at.strftime('%m/%d/%Y')"
    attrs["Subject"]              = "notification.messages.any?{ |m| m.id < self.id } ? '' : notification.subject"
    attrs["Content"]              = "body"

    attrs
  end

  ################## END REPORT SETUP  #####################

  ################## BEGIN QUERY SETUP #####################
  # def table => primary table to query
  # includes, where, uniq, order, and group get passed to AR methods, http://apidock.com/rails/v3.2.13/ActiveRecord/QueryMethods
  # def includes => other tables to include
  # def where => conditions for query
  # def uniq => return distinct records
  # def group => group by this attribute (including table name is always a safe bet, ex. identities.id)
  # def order => order by these attributes (include table name is always a safe bet, ex. identities.id DESC, protocols.title ASC)
  # Primary table to query
  def table
    Message
  end

  # Other tables to include
  def includes
    [:sender, :recipient, notification: [:messages, sub_service_request: :organization ]]
  end

  # Conditions
  def where(args={})
    selected_organization_id = args[:core_id] || args[:program_id] || args[:provider_id] || args[:institution_id] # we want to go up the tree, service_organization_ids plural because we might have child organizations to include
    ssr_organization_ids = [args[:core_id], args[:program_id], args[:provider_id], args[:institution_id]].compact

    # get child organizations
    unless ssr_organization_ids.empty?
      org = Organization.find(selected_organization_id)
      ssr_organization_ids = [ssr_organization_ids, org.all_child_organizations_with_self.map(&:id)].flatten
    end

    # default values if none are provided
    ssr_organization_ids = Organization.all.ids if ssr_organization_ids.compact.empty? # use all if none are selected

    created_at =
      if args[:messages_created_at_from] && args[:messages_created_at_to]
        DateTime.strptime(args[:messages_created_at_from], "%m/%d/%Y").to_s(:db)..DateTime.strptime(args[:messages_created_at_to], "%m/%d/%Y").strftime("%Y-%m-%d 23:59:59")
      else
        self.default_options["Date Range"][:from].to_s(:db)..self.default_options["Date Range"][:to].to_datetime.strftime("%Y-%m-%d 23:59:59")
      end

    return { organizations: { id: ssr_organization_ids }, notifications: { created_at: created_at } }
  end

  # Return only uniq records for
  def uniq
  end

  def group
  end

  def order
    "notifications.id DESC, messages.id ASC"
  end
end
