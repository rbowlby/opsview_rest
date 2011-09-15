module OpsviewRest
  module Util

    def resource_path(full=false)
      if (full == true || full == :full)
        "/rest/config/#{self.type}"
      else
        "config/#{self.type}"
    end

    def list
      self.opsview.get(resource_path)
    end

    def save(replace=false)
      if replace == true || replace == :replace
        self.opsview.put(self.resource_path, self)
      else
        self.opsview.post(self.resource_path, self)
      end
    end

  end
end
