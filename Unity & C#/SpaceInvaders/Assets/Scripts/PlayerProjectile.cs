using UnityEngine;
using System.Collections;

public class PlayerProjectile : MonoBehaviour {

	public GameObject spawnPosObj;
	public GameObject bullet;
	public EnemyBulletScript newBS; 
	private float timer = 0.0f;

	// Use this for initialization
	void Start () {

	}
	
	// Update is called once per frame
	void Update () {
		if(newBS.playerAlive == true){
			timer += Time.deltaTime;
			if((Input.GetKey (KeyCode.Space) || Input.GetMouseButtonDown(0)) && timer > 0.5f){
				Instantiate(bullet, spawnPosObj.transform.position, Quaternion.identity);
				timer = 0.0f;
			}	
		}
	}
}
