package com.supermap.map3D.toolKit;

import java.util.List;

public class PoiGsonBean {
	private List<PoiInfos> poiInfos;

	private int totalHits;

	public void setPoiInfos(List<PoiInfos> poiInfos) {
		this.poiInfos = poiInfos;
	}

	public List<PoiInfos> getPoiInfos() {
		return this.poiInfos;
	}

	public void setTotalHits(int totalHits) {
		this.totalHits = totalHits;
	}

	public int getTotalHits() {
		return this.totalHits;
	}

	public static class PoiInfos {
		private String address;

		private Location location;

		private String name;

		private int score;

		private String telephone;

		private String uid;

		public void setAddress(String address) {
			this.address = address;
		}

		public String getAddress() {
			return this.address;
		}

		public void setLocation(Location location) {
			this.location = location;
		}

		public Location getLocation() {
			return this.location;
		}

		public void setName(String name) {
			this.name = name;
		}

		public String getName() {
			return this.name;
		}

		public void setScore(int score) {
			this.score = score;
		}

		public int getScore() {
			return this.score;
		}

		public void setTelephone(String telephone) {
			this.telephone = telephone;
		}

		public String getTelephone() {
			return this.telephone;
		}

		public void setUid(String uid) {
			this.uid = uid;
		}

		public String getUid() {
			return this.uid;
		}

	}

	public class PathInfos {

		public double pathLength;
		public List<Location> pathPoints;

		public double getPathLength() {

			return pathLength;
		}

		public void setPathLength() {

			this.pathLength = pathLength;

		}

		public List<Location> getPathPoints() {

			return pathPoints;
		}

		public void setPathPoints(List<Location> pathPoints) {

			this.pathPoints = pathPoints;

		}
	}

	public static class Location {

		private double x;

		private double y;

		public void setX(double x) {
			this.x = x;
		}

		public double getX() {
			return this.x;
		}

		public void setY(double y) {
			this.y = y;
		}

		public double getY() {
			return this.y;
		}
	}

	public static class Junction {

		private double x;

		private double y;

		public void setX(double x) {
			this.x = x;
		}

		public double getX() {
			return this.x;
		}

		public void setY(double y) {
			this.y = y;
		}

		public double getY() {
			return this.y;
		}
	}
}
