/**
 * Service class for making callouts to the Jira API
 */
public with sharing class JiraAPIService {
	/**
	 * Creates a project in Jira
	 * @param projectWrapper The project wrapper object containing all necessary data
	 * @return String The Jira project ID
	 *
	 * TODO: Implement this method to make a callout to Jira API to create a project
	 * Reminder: Extract and return the project ID from the response
	 */

	public static final String JIRA_NC_NAME    = 'JiraCCA';
	public static final String JIRA_BASE_URL   = 'callout:' + JIRA_NC_NAME;
	private static final String PROJECT_PATH   = '/project';
	private static final String ISSUE_PATH     = '/issue';

	// Full endpoints you can reference anywhere
	public static final String PROJECT_ENDPOINT = JIRA_BASE_URL + PROJECT_PATH;
	public static final String ISSUE_ENDPOINT   = JIRA_BASE_URL + ISSUE_PATH;

	 // Custom exception
    public class JiraAPIException extends Exception {}

	// *****I tried using Nebula.logger but just could not stop getting errors about unreachable variables
	// *****so I just used System.debug for now. I'll try Nebula on the next homework. 

	public static String createProject(JiraWrapper.ProjectWrapper projectWrapper) {
	// Your implementation goes here
		System.debug ('***createProject START ' + projectWrapper.key);

	try {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(PROJECT_ENDPOINT);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        String body = JSON.serialize(projectWrapper);
        req.setBody(body);

        System.debug('***createProject: ' + PROJECT_ENDPOINT);
        System.debug('***createProject payload: ' + body);

        HttpResponse res = new Http().send(req);

        System.debug('***createProject status: ' + res.getStatusCode());
        System.debug('***createProject response: ' + res.getBody());

        if (res.getStatusCode() == 201) {
                Map<String,Object> result =
                  (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
                String jiraId = String.valueOf(result.get('id'));
               
                return jiraId;
            }else{
				return null;
			}
            

		} catch (Exception e) {
			System.debug('***createProject ERROR ' + e.getMessage());
			return null;
		} finally {
			System.debug('***createProject END');
		}
	}
		

	/**
	 * Creates an issue in Jira
	 * @param issueWrapper The issue wrapper object containing all necessary data
	 * @return String The Jira issue key
	 *
	 * TODO: Implement this method to make a callout to Jira API to create an issue
	 * Reminder: Extract and return the issue key from the response
	 */
	public static String createIssue(JiraWrapper.IssueWrapper issueWrapper) {
		// Your implementation goes here
		

		try {
			HttpRequest req = new HttpRequest();
			req.setEndpoint(ISSUE_ENDPOINT);
			req.setMethod('POST');
			req.setHeader('Content-Type', 'application/json');
			String body = JSON.serialize(issueWrapper.generateIssuePayloadMap());
			req.setBody(body);

			
			System.debug('***createIssue payload: ' + body);

			HttpResponse res = new Http().send(req);

			System.debug('***createIssue status: ' + res.getStatusCode());
			System.debug('***createIssue response: ' + res.getBody());

			if (res.getStatusCode() == 201) {
                Map<String,Object> result =
                  (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
                String jiraKey = String.valueOf(result.get('key'));
                
                return jiraKey;
            }else{
				 return null;
			}           

		} catch (Exception e) {
			System.debug('***createIssue ERROR ' + e.getMessage());
			return null;

		} finally {
			System.debug('***createIssue END');
		}

	}
}
