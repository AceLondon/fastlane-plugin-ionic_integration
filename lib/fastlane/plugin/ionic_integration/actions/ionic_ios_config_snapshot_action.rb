require 'xcodeproj'
require 'fastlane/plugin/ionic_integration/constants'

module Fastlane
  module Actions
    #
    # Used to bootstrap the UI Unit Testing Process for iOS generated Xcode Projects.
    #
    # It copies over a sample UI test to our fastlane config folder and runs the IonicSnapShotAction
    #
    class IonicIosConfigSnapshotAction < Action
      def self.run(params)
        #
        # Params
        #
        scheme_name = params[:ionic_scheme_name]
        workspace_path = params[:ionic_ios_xcode_path]
        target_os = params[:ionic_min_target_ios]
        
        #
        # Copy over unit test files
        #
        UI.message("Creating New UI Unit Tests for Snapshots, with Scheme '#{scheme_name}' in '#{IonicIntegration::IONIC_IOS_CONFIG_UITESTS_PATH}'")
        Fastlane::Helper::IonicIntegrationHelper.copy_ios_sample_tests(scheme_name)

        #
        # Just call our main ios snapshot action, if there is a workspace
        #
        if Dir.exist?(workspace_path)
          UI.message("Switching over to action `ionic_ios_snapshot_action` with params `ionic_ios_xcode_path`=#{workspace_path}, `ionic_min_target_ios`=#{target_os}")
          #other_action.ionic_ios_snapshot(
          Actions::IonicIosSnapshotAction.run(  
            ionic_ios_xcode_path: workspace_path,
            ionic_min_target_ios: target_os
          )
          UI.success("Created UI Test Configuration")
        elsif
          UI.success("Created UI Test Configuration. No Workspace exists or was specified yet. When ionic generates the workspace you'll need to call the `ionic_ios_snapshot` action.")
        end
      end

      def self.description
        'Create a Sample iOS UI Unit Test to get started with in a generated Ionic/Cordova project'
      end

      def self.authors
        ['Adrian Regan']
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Creates a set of UI Unit Tests in '#{IonicIntegration::IONIC_IOS_CONFIG_UITESTS_PATH}' and configures an existing Ionic/Cordova Generated Xcode projec to use them"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :ionic_ios_xcode_path,
                                       env_name: 'IONIC_IOS_XCODE_PATH',
                                       description: 'Path to Xcode Project Generated by Ionic',
                                       default_value: Fastlane::Helper::IonicIntegrationHelper.find_default_ios_xcode_workspace,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :ionic_min_target_ios,
                                       env_name: 'IONIC_MIN_TARGET_IOS',
                                       description: 'Minimal iOS Version to Target',
                                       default_value: IonicIntegration::DEFAULT_IOS_VERSION,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :ionic_scheme_name,
                                       env_name: 'IONIC_IOS_TEST_SCHEME',
                                       description: 'Scheme Name of the UI Unit Tests',
                                       default_value: IonicIntegration::IONIC_DEFAULT_UNIT_TEST_NAME,
                                       optional: false)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Platforms.md
        #
        # [:ios, :mac, :android].include?(platform)
        [:ios].include?(platform)
      end
    end
  end
end
