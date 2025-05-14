/**
 * Wrapper classes for Jira entities (Project and Issue)
 */
public class JiraWrapper {
	// private static final String LEAD_ACCOUNT_ID = '603f45e530320b00694da932';
	// private static final String PROJECT_TEMPLATE_KEY = 'com.pyxis.greenhopper.jira:basic-software-development-template';
	// private static final String PROJECT_TYPE_KEY = 'software';

	// Moved to Custom Metadata
	private static final Jira_Integration_Config__mdt CFG =
    	Jira_Integration_Config__mdt.getInstance('Default');
	/**
	 * Wrapper for Jira Project
	 */
	public class ProjectWrapper {
		public String name;
		public String key;
		public String description;
		public String leadAccountId;
		public String projectTypeKey;
		public String projectTemplateKey;

		/**
		 * Constructor for ProjectWrapper
		 */
		public ProjectWrapper(String name, String key, String description) {
			this.name = name;
			this.key = key;
			this.description = description;
			this.leadAccountId = CFG.Lead_Account_Id__c;
			this.projectTypeKey = CFG.Project_Type_Key__c;
			this.projectTemplateKey = CFG.Project_Template_Key__c;
		}
	}

	/**
	 * Wrapper for Jira Issue
	 */
	public class IssueWrapper {
		public String name;
		public String key;
		public String description;
		public String projectKey;
		public String summary;
		public String issueType;

		/**
		 * Constructor for IssueWrapper
		 */
		public IssueWrapper(
			String projectKey,
			String summary,
			String description,
			String issueType
		) {
			this.projectKey = projectKey;
			this.summary = summary;
			this.description = description;
			this.issueType = (String.isNotBlank(issueType)) ? issueType : 'Task';
		}

		/**
		 * Convert IssueWrapper to a Map for serialization
		 *
		 * TODO: Implement this method to create a Map that represents
		 * the JSON payload needed for the Jira API. The Map should contain:
		 * - fields object with project information (key)
		 * - issuetype object with the issue type name
		 * - summary field
		 * - description field (formatted using formatDescription method)
		 * - Example:
		 */
		public Map<String, Object> generateIssuePayloadMap() {
			// Your implementation goes here
			// Build the nested “fields” map
			
			Map<String, Object> fields = new Map<String, Object>{
				'project'   => new Map<String, Object>{ 'key'  => projectKey },
				'issuetype' => new Map<String, Object>{ 'name' => issueType },
				'summary'   => summary,
				'description' => formatDescription(description)
				};
			  
			  // Top-level payload
			  return new Map<String, Object>{ 'fields' => fields };
		}

		/**
		 * Format description as per Jira Cloud API requirements
		 *
		 * TODO: Implement this method to format the description text
		 * according to Jira Cloud API requirements.
		 * - Create a Map with type="doc" and version=1
		 * - Add content array with paragraph object
		 * - Add text object inside paragraph content with the description
		 * - Example:
		 *   {
		 *     "description": {
		 *       "type": "doc",
		 *       "version": 1,
		 *       "content": [
		 *         {
		 *           "type": "paragraph",
		 *           "content": [
		 *             {
		 *               "type": "text",
		 *               "text": "Order entry fails when selecting supplier."
		 *             }
		 *           ]
		 *         }
		 *       ]
		 *     }
		 *   }
		 */
		private Map<String, Object> formatDescription(String descText) {
			// Your implementation goes here// Text node
            Map<String, Object> textNode = new Map<String, Object>{
                'type' => 'text',
                'text' => descText
            };

            // Paragraph node wrapping the text
            Map<String, Object> paragraphNode = new Map<String, Object>{
                'type'    => 'paragraph',
                'content' => new List<Object>{ textNode }
            };

            // The doc root
            return new Map<String, Object>{
                'type'    => 'doc',
                'version' => 1,
                'content' => new List<Object>{ paragraphNode }
            };
		}
	}
}
