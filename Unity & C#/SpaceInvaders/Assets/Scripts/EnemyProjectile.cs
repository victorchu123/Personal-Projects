using UnityEngine;
using System.Collections;

public class EnemyProjectile : MonoBehaviour {

	public GameObject spawnPosObj;
	public GameObject bullet;
	public BulletScript newBS; 
	private float timer = 0.0f;

	
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		if(newBS.enemyAlive == true){
			timer += Time.deltaTime;
			if(timer > 1.2f){
				Instantiate(bullet, spawnPosObj.transform.position, Quaternion.identity);
				timer = 0.0f;
			}
		}
	}
}
