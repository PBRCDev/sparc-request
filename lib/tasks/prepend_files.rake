# Copyright 2011 MUSC Foundation for Research Development
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

namespace :file do
  desc "Add text to the top of a file"
  task :prepend_files => :environment do
    
    def file_prepend(file, str, prefix, postfix)
      f = File.open(file, "r+")
      lines = f.readlines
      f.close

      str = str.gsub(/#/, prefix)
      str = str.gsub(/~/, postfix)

      lines = [str] + lines

      output = File.new(file, "w")
      lines.each { |line| output.write line }
      output.close
    end

    # The copyright header needed for each file
    # # and ~ are keys to replace for different comment styles
    header = "# Copyright 2011 MUSC Foundation for Research Development~\n"
    header += "# All rights reserved.~\n\n"
    header += "# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:~\n\n"
    header += "# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.~\n\n"
    header += "# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following~\n"
    header += "# disclaimer in the documentation and/or other materials provided with the distribution.~\n\n"
    header += "# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products~\n"
    header += "# derived from this software without specific prior written permission.~\n\n"
    header += "# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,~\n"
    header += "# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT~\n"
    header += "# SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL~\n"
    header += "# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS~\n"
    header += "# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR~\n"
    header += "# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.~\n\n"

    # Grab all files in application
    all = File.join('**', '*.*')

    # A list of files and folders to ignore
    files_to_ignore = ['tmp/', 'import/', '.png', '.gif', '.jpeg', '.jpg', 'jquery', '.xcf', '.svg', '.pdf', '.cur', '.md',
                       'schema', '.csv', '.log', 'public/', '.doc', '.sql', '.lock', '.xml']

    # Comment Styles
    # .rb #
    # .coffee #
    # .xlsx #
    # .yml #
    # .rake #
    # .haml -#
    # .js //
    # .erb <%# %>
    # .scss //
    # .sass //
    # .css /* */

    # Get the list of all ignored files
    ignored_files = Dir.glob(all).select { |x| files_to_ignore.detect { |y| x.include? y } }
    puts 'These files were ignored'
    puts ignored_files
    puts ignored_files.count
    puts "Above are ignored files"

    # Get a list of all files that could need the copyright information
    file_list = Dir.glob(all).reject { |x| files_to_ignore.detect { |y| x.include? y } }
    file_types = ['.rb', '.coffee', '.xlsx', '.yml', '.rake', '.haml', '.js', '.erb', '.scss', '.sass', '.css', '.ru', '.txt']
    prefixes =   ['#',   '#',       '#',     '#',    '#',     '-#',    '//',  '<%#',  '//',    '//',    '/*',   '#',   '']
    postfixes =  ['',    '',        '',      '',     '',      '',      '',    '%>',   '',      '',      '*/',   '',    '']

    # Loop over each file type and pass in the comment style for each file
    file_types.each_with_index do |type, index|
      # Grab the list of files that match the type we're currently looking at
      subset_list = file_list.select { |file| file.include? type }

      # Add copyright info to the top of each file
      subset_list.each do |file|
        file_prepend(file, header, prefixes[index], postfixes[index])
      end

      # To prevent adding the copyright to a file more than once, clean out the ones we just did.
      file_list.reject! { |file| file.include? type }

      # Print out of the files that were changed with their corresponding type and comment style
      puts subset_list
      puts "File Type: #{type}"
      puts "Prefix: #{prefixes[index]}"
      puts "Postfix: #{postfixes[index]}"
      puts subset_list.count
      puts ''
    end

    # In case something was missed, print out any files that were found but not changed.
    puts "These files need to be changed"
    puts file_list

  end
end