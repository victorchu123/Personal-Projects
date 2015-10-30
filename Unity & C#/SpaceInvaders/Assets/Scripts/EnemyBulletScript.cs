using UnityEngine;
using System.Collections;

public class EnemyBulletScript : MonoBehaviour {
	public bool playerAlive = true;
	private BasicMovement playerScript;
	private bool playerHit = false;


	// Use this for initialization
	void Start () {
		playerScript = GameObject.FindGameObjectWithTag("Player").GetComponent<BasicMovement>();
	}
	
	// Update is called once per frame
	void Update () {
		transform.Translate(Vector3.down *20* Time.deltaTime);
		if(Camera.main.WorldToViewportPoint(this.transform.position).y > 1){
			Destroy(this.gameObject);
		}

	}
	void OnTriggerEnter(Collider other){
		if (playerHit == false){
			if(other.GetComponent<Collider>().tag == "Player"){
				//playerHit = true;
				playerScript.LoseLives();
				other.GetComponent<AudioSource>().Play();
				Destroy (this.gameObject);
				//StartCoroutine(Wait ());
				//playerHit = false;

			}
			if(other.GetComponent<Collider>().tag == "Platform"){
				Destroy (other.gameObject);
				Destroy (this.gameObject);
			}
		}
	}
	/*IEnumerator Wait(){
		yield return new WaitForSeconds(3);
		Debug.Log ("I do something");
	}*/

}
