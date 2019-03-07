resource_name 'insert_line_after'

property :file, String
property :path, String
property :line, [String, Regexp], required: true
property :insert, String, required: true

action :run do
  file_path = new_resource.file || new_resource.path || new_resource.name

  # Check if we got a regex or a string
  regex = if new_resource.line.is_a?(Regexp)
            new_resource.line
          else
            Regexp.new(Regexp.escape(new_resource.line))
          end

  insert_regex = Regexp.new(Regexp.escape(new_resource.insert))

  # Check if file matches the regex
  if ::File.read(file_path) =~ regex && ::File.read(file_path) !~ insert_regex
    # Calculate file hash before changes
    before = Digest::SHA256.file(file_path).hexdigest

    # Do changes
    file = Chef::Util::FileEdit.new(file_path)
    file.insert_line_after_match(regex, new_resource.insert)
    file.write_file

    # Notify file changes
    if Digest::SHA256.file(file_path).hexdigest != before
      Chef::Log.info "+ #{new_resource.insert}"
      new_resource.updated_by_last_action(true)
    end

    # Remove backup file
    ::File.delete(file_path + '.old') if ::File.exist?(file_path + '.old')
  end
end
