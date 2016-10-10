using UnityEngine;
using System.Collections;

public class BossProjectile : MonoBehaviour {

	public GameObject spawnPosObj;
	public GameObject bossBullet;
	public EnemyBulletScript newBS; 
	private float timer = 0.0f;
	
	
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {

		//check if player is still in play
		if(newBS.playerAlive == true){
			timer += Time.deltaTime;
			//enemy space invaders bullets spawns every 0.7 secs
			if (timer >0.6f){
				Instantiate(bossBullet, spawnPosObj.transform.position, Quaternion.identity);
				timer = 0.0f;
			}
		}
	}
}
