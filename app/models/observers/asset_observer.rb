# Copyright 2018 Square Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

# This is an observer on the {Asset} model.
# 1) Triggers imports and re-imports of Assets, when necessary.

class AssetObserver < ActiveRecord::Observer

  # Be careful when writing any code that runs callbacks in after_commit hooks, unless it is the last method in the after_commit hook.
  # Remember that calling save on the record in its after_commit hook will change the previous_changes hash.
  #
  # Trigger a re-import if any field that would require an import when changed has changed. Ex: targeted_rfc5646_locales
  # This will take care of the initial import as well since file will have changed.

  def after_commit(asset)
    if Asset::FIELDS_THAT_REQUIRE_IMPORT_WHEN_CHANGED.any? {|field| asset.previous_changes.include?(field)}
      asset.import!
    end
  end
end
