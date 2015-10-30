using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class BasicMovement : MonoBehaviour {
	
	public int speed = 10;
	public Text livesText;
	private int lives = 3;
	public Text scoreText; 
	private int score = 0;



	// Use this for initialization
	void Start () {

	}
	
	// Update is called once per frame
	void Update () {
		scoreText.text = "Score: " + score;
		livesText.text = "Lives: " + lives;

		//touch controls
		/*if(Input.GetTouch(0).phase == TouchPhase.Stationary){

			if(Input.GetTouch(0).position.x > Screen.width / 2){
				transform.Translate(Vector3.right * speed * Time.deltaTime);
			}
			if(Input.GetTouch(0).position.x < Screen.width / 2){
				transform.Translate(Vector3.left * speed * Time.deltaTime);
			}
		}*/

		/*if(Mathf.Abs (Input.acceleration.x) > 0.1f){
			float xDir = Mathf.Sign (Input.acceleration.x);
			transform.Translate(Vector3.right * speed * xDir * Time.deltaTime);

		}
		if(Mathf.Abs (Input.acceleration.x) < 0.1f){
			float xDir = Mathf.Sign (Input.acceleration.x);
			transform.Translate(Vector3.left * speed * xDir * Time.deltaTime);
			
		}*/

		// PC controls
		if (Input.GetKey (KeyCode.A) || Input.GetKey(KeyCode.LeftArrow)) {
			transform.Translate(Vector3.left * speed * Time.deltaTime); 
		}
		if (Input.GetKey (KeyCode.D) || Input.GetKey(KeyCode.RightArrow)) {
			transform.Translate(Vector3.right * speed * Time.deltaTime); 
		}
		
	}

	public void LoseLives(){

			if(lives>1){
				lives--;
			}
			else{
				lives--; 
				Application.LoadLevel("GameOver");
			}
	}
	public void gainMinScore(){
		if(score >= 0){
			score += 10;
		}
	}
	public void gainMaxScore(){
		if(score >= 0){
			score += 50;
		}
	}


}
