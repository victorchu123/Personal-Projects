using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class BasicMovement : MonoBehaviour {
	
	public int speed = 10;
	public Text livesText;
	private int lives = 3;
	public Text scoreText; 
	public int score = 0;



	// Use this for initialization
	void Start () {
		this.transform.position = new Vector3(6.5f,0.5f,-20.02f);
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

	//method called when object is hit.
	public void LoseLives(){

			if(lives>1){
				lives--;
			}
			else{
				lives--; 
				Application.LoadLevel("GameOver");
			}
	}

	//increases score for killing smaller space invaders
	public void gainMinScore(){
		if(score >= 0){
			score += 10;
		}
	}

	//increases score for killing larger space invaders
	public void gainMaxScore(){
		if(score >= 0){
			score += 50;
		}
	}

	//handles when player hits the left boundary
	public void hitLeftWall(){
		transform.Translate(Vector3.right * 10 * Time.deltaTime);
	}

	//handles when player hits the right boundary
	public void hitRightWall(){
		transform.Translate(Vector3.left * 10 * Time.deltaTime);
	}

}
